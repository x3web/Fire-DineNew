<?php
declare(strict_types=1);

namespace FireDine;

use DomainException;
use PDO;

final class ProductRepository
{
    private const PUBLIC_PRODUCT_FIELDS = [
        'id'=>true,'name'=>true,'sku'=>true,'slug'=>true,'short_description'=>true,'description'=>true,
        'regular_price'=>true,'sale_price'=>true,'stock_status'=>true,'product_type'=>true,'featured'=>true,
        'sort_order'=>true,'seo_title'=>true,'seo_description'=>true,'category_name'=>true,'category_slug'=>true,
        'parent_category_name'=>true,'parent_category_slug'=>true,'min_variation_price'=>true,
        'max_variation_price'=>true,'image_url'=>true,'specifications_data'=>true,'attributes'=>true,
        'category'=>true,'variation_min_price'=>true,'variation_max_price'=>true,'size_variation_guide'=>true,
    ];

    public function __construct(private PDO $db) {}

    public function categories(): array
    {
        $rows = $this->db->query("SELECT id,name,slug,parent_id,sort_order FROM categories WHERE is_active=1 ORDER BY COALESCE(parent_id,0),sort_order,name")->fetchAll();
        $byParent = [];
        foreach ($rows as $row) $byParent[(string)($row['parent_id'] ?? 0)][] = $row;
        foreach ($rows as &$row) $row['children'] = $byParent[(string)$row['id']] ?? [];unset($row);
        $public=[];foreach(array_filter($rows,fn($row)=>$row['parent_id']===null) as $row){$children=[];foreach($row['children'] as $child)$children[]=['name'=>$child['name'],'slug'=>$child['slug']];$public[]=['name'=>$row['name'],'slug'=>$row['slug'],'children'=>$children];}return$public;
    }

    public function list(array $filters = []): array
    {
        $filters['per_page'] ??= 48;
        return $this->search($filters)['products'];
    }

    public function search(array $filters = []): array
    {
        $page = max(1, (int)($filters['page'] ?? 1));
        $perPage = max(1, min(48, (int)($filters['per_page'] ?? 24)));
        $where = ["p.status='active'", "p.visibility='visible'"];
        $params = [];
        $query = trim((string)($filters['q'] ?? ''));
        if ($query !== '') {
            if (strlen($query) > 100) throw new DomainException('Search text is too long.');
            $where[] = '(p.name LIKE ? OR p.short_description LIKE ? OR p.description LIKE ? OR p.sku LIKE ?)';
            $term = '%'.$query.'%';
            array_push($params,$term,$term,$term,$term);
        }
        if (isset($filters['featured']) && $filters['featured'] !== '') {
            $featured = filter_var($filters['featured'], FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
            if ($featured === null) throw new DomainException('Featured must be true or false.');
            $where[] = 'p.featured=?'; $params[] = $featured ? 1 : 0;
        }
        $category = trim((string)($filters['category'] ?? ''));
        $subcategory = trim((string)($filters['subcategory'] ?? ''));
        if ($subcategory !== '') {
            $stmt = $this->db->prepare("SELECT child.id FROM categories child JOIN categories parent ON parent.id=child.parent_id WHERE child.slug=? AND child.is_active=1 AND parent.is_active=1".($category!==''?' AND parent.slug=?':'')." LIMIT 1");
            $stmt->execute($category!==''?[$subcategory,$category]:[$subcategory]);
            $id = $stmt->fetchColumn();
            if ($id === false) throw new NotFoundException('The selected subcategory does not belong to this category.');
            $where[]='p.category_id=?';$params[]=(int)$id;
        } elseif ($category !== '') {
            $stmt=$this->db->prepare("SELECT id FROM categories WHERE slug=? AND is_active=1 LIMIT 1");$stmt->execute([$category]);$id=$stmt->fetchColumn();
            if($id===false)throw new NotFoundException('Category not found.');
            $ids=[(int)$id];$child=$this->db->prepare("SELECT id FROM categories WHERE parent_id=? AND is_active=1");$child->execute([(int)$id]);foreach($child->fetchAll(PDO::FETCH_COLUMN) as $childId)$ids[]=(int)$childId;
            $where[]='p.category_id IN ('.implode(',',array_fill(0,count($ids),'?')).')';array_push($params,...$ids);
        }
        $whereSql=implode(' AND ',$where);
        $count=$this->db->prepare("SELECT COUNT(*) FROM products p WHERE $whereSql");$count->execute($params);$total=(int)$count->fetchColumn();
        $offset=($page-1)*$perPage;
        $sql=$this->publicSelect()." WHERE $whereSql ORDER BY p.featured DESC,p.sort_order,p.name LIMIT $perPage OFFSET $offset";
        $stmt=$this->db->prepare($sql);$stmt->execute($params);
        return ['products'=>array_map([$this,'normalise'],$stmt->fetchAll()),'pagination'=>['page'=>$page,'per_page'=>$perPage,'total'=>$total,'pages'=>(int)max(1,ceil($total/$perPage))]];
    }

    public function findBySlug(string $slug): ?array
    {
        if(!preg_match('/^[a-z0-9]+(?:-[a-z0-9]+)*$/',$slug))return null;
        $stmt=$this->db->prepare($this->publicSelect()." WHERE p.slug=? AND p.status='active' AND p.visibility='visible' LIMIT 1");$stmt->execute([$slug]);$row=$stmt->fetch();
        if(!$row)return null;$product=$this->normalise($row);$product['variations']=$this->variations((int)$product['id']);$product['options']=$this->options((int)$product['id']);$product['related']=$this->related((int)$product['id']);$product['gallery']=$this->gallery((int)$product['id']);return $this->sanitizePublicValue($product);
    }

    public function findPublic(int $id): ?array
    {
        $stmt=$this->db->prepare($this->publicSelect()." WHERE p.id=? AND p.status='active' AND p.visibility='visible' LIMIT 1");$stmt->execute([$id]);$row=$stmt->fetch();return $row?$this->normalise($row):null;
    }

    public function variations(int $productId): array
    {
        $stmt=$this->db->prepare("SELECT id,sku,regular_price,sale_price,stock_status,attributes_json,position FROM product_variations WHERE product_id=? AND enabled=1 ORDER BY position,id");$stmt->execute([$productId]);
        return array_map(function(array $row){$row['attributes']=$this->sanitizePublicValue(json_decode($row['attributes_json']?:'{}',true)?:[]);$row['available']=$row['stock_status']!=='out_of_stock';unset($row['attributes_json']);return $row;},$stmt->fetchAll());
    }

    public function options(int $productId,bool $internal=false): array
    {
        $stmt=$this->db->prepare("SELECT g.id,g.option_code,g.public_label,g.selection_type,g.is_required,g.display_order,g.metadata_json,v.id value_id,v.value_code,v.public_label value_label,v.price_adjustment,v.pricing_mode,v.is_default,v.display_order value_order,v.conditions_json,v.metadata_json value_metadata FROM product_option_groups g LEFT JOIN product_option_values v ON v.option_group_id=g.id AND v.is_active=1 WHERE g.product_id=? AND g.is_active=1 ORDER BY g.display_order,g.id,v.display_order,v.id");$stmt->execute([$productId]);$groups=[];
        foreach($stmt->fetchAll() as $row){$id=(int)$row['id'];$metadata=json_decode($row['metadata_json']?:'{}',true)?:[];if(!$internal)$metadata=array_intersect_key($metadata,['required_when'=>true]);$groups[$id]??=['id'=>$id,'code'=>$row['option_code'],'label'=>$row['public_label'],'type'=>$row['selection_type'],'required'=>(bool)$row['is_required'],'display_order'=>(int)$row['display_order'],'metadata'=>$metadata,'values'=>[]];if($row['value_id']!==null)$groups[$id]['values'][]=['id'=>(int)$row['value_id'],'code'=>$row['value_code'],'label'=>$row['value_label'],'price_adjustment'=>$row['price_adjustment'],'pricing_mode'=>$row['pricing_mode'],'default'=>(bool)$row['is_default'],'display_order'=>(int)$row['value_order'],'conditions'=>json_decode($row['conditions_json']?:'{}',true)?:[],'metadata'=>$internal?(json_decode($row['value_metadata']?:'{}',true)?:[]):[]];}
        return array_values($groups);
    }

    public function related(int $productId): array
    {
        $stmt=$this->db->prepare("SELECT p.id,p.name,p.sku,p.slug,p.short_description,p.regular_price,p.sale_price,p.stock_status,p.product_type,p.featured,p.seo_title,p.seo_description,c.name category_name,c.slug category_slug,pc.name parent_category_name,pc.slug parent_category_slug,m.storage_key image_key,r.context_label,(SELECT MIN(COALESCE(v.sale_price,v.regular_price)) FROM product_variations v WHERE v.product_id=p.id AND v.enabled=1 AND v.stock_status<>'out_of_stock') min_variation_price,(SELECT MAX(COALESCE(v.sale_price,v.regular_price)) FROM product_variations v WHERE v.product_id=p.id AND v.enabled=1 AND v.stock_status<>'out_of_stock') max_variation_price FROM product_related_products r JOIN products p ON p.id=r.related_product_id LEFT JOIN categories c ON c.id=p.category_id LEFT JOIN categories pc ON pc.id=c.parent_id LEFT JOIN media_assets m ON m.id=p.thumbnail_media_id WHERE r.product_id=? AND r.is_active=1 AND p.status='active' AND p.visibility='visible' ORDER BY r.display_order,p.name");$stmt->execute([$productId]);return array_map([$this,'normalise'],$stmt->fetchAll());
    }

    public function gallery(int $productId): array
    {
        $stmt=$this->db->prepare("SELECT m.storage_key,m.original_name,m.mime_type,pm.sort_order,pm.is_primary FROM product_media pm JOIN media_assets m ON m.id=pm.media_id WHERE pm.product_id=? ORDER BY pm.is_primary DESC,pm.sort_order,pm.media_id");$stmt->execute([$productId]);return array_map(fn($row)=>['url'=>'/uploads/'.ltrim($row['storage_key'],'/'),'alt'=>$row['original_name']?:'Fire & Dine product image','mime_type'=>$row['mime_type'],'primary'=>(bool)$row['is_primary']],$stmt->fetchAll());
    }

    private function publicSelect(): string
    {
        return "SELECT p.id,p.name,p.sku,p.slug,p.short_description,p.description,p.regular_price,p.sale_price,p.stock_status,p.product_type,p.featured,p.sort_order,p.seo_title,p.seo_description,p.specifications,p.attributes_json,c.name category_name,c.slug category_slug,pc.name parent_category_name,pc.slug parent_category_slug,m.storage_key image_key,(SELECT MIN(COALESCE(v.sale_price,v.regular_price)) FROM product_variations v WHERE v.product_id=p.id AND v.enabled=1 AND v.stock_status<>'out_of_stock') min_variation_price,(SELECT MAX(COALESCE(v.sale_price,v.regular_price)) FROM product_variations v WHERE v.product_id=p.id AND v.enabled=1 AND v.stock_status<>'out_of_stock') max_variation_price FROM products p LEFT JOIN categories c ON c.id=p.category_id LEFT JOIN categories pc ON pc.id=c.parent_id LEFT JOIN media_assets m ON m.id=p.thumbnail_media_id";
    }

    private function normalise(array $row): array
    {
        $row['image_url']=!empty($row['image_key'])?'/uploads/'.ltrim($row['image_key'],'/'):'/assets/images/logo/fire-dine-full-logo.png';unset($row['image_key']);
        if(isset($row['specifications']))$row['specifications_data']=$this->sanitizePublicValue(json_decode($row['specifications']?:'{}',true)?:[]);
        if(isset($row['attributes_json']))$row['attributes']=$this->sanitizePublicValue(json_decode($row['attributes_json']?:'{}',true)?:[]);
        $row['category']=$row['category_name']??null;
        $row['variation_min_price']=$row['min_variation_price']??null;
        $row['variation_max_price']=$row['max_variation_price']??null;
        $sizeValues=(array)($row['attributes']['Size']??$row['attributes']['size']??[]);
        $models=(array)($row['specifications_data']['models']??[]);
        if($sizeValues){
            $items=[];
            foreach($sizeValues as $size){
                $model=null;
                foreach($models as $candidate){if(is_array($candidate)&&strcasecmp(trim((string)($candidate['model']??'')),trim((string)$size))===0){$model=$candidate;break;}}
                $items[]=['value'=>(string)$size,'label'=>(string)$size,'dimensions'=>[
                    'front_to_back'=>(string)($model['front_to_back']??'—'),
                    'side_to_side'=>(string)($model['side_to_side']??'—'),
                    'inner_diameter'=>(string)($model['inner_diameter']??$model['inside_diameter']??'—'),
                ]];
            }
            $row['size_variation_guide']=['attribute'=>array_key_exists('Size',$row['attributes'])?'Size':'size','items'=>$items];
        }
        unset($row['specifications'],$row['attributes_json']);
        return array_intersect_key($row,self::PUBLIC_PRODUCT_FIELDS);
    }

    private function sanitizePublicValue(mixed $value): mixed
    {
        if(!is_array($value))return$value;
        $clean=[];
        foreach($value as $key=>$item){
            if(is_string($key)&&$this->isInternalKey($key))continue;
            $clean[$key]=$this->sanitizePublicValue($item);
        }
        return$clean;
    }

    private function isInternalKey(string $key): bool
    {
        $key=strtolower(str_replace(['-',' '],'_',$key));
        foreach(['legacy_label','confirmation','provisional','internal','migration','administrative','admin_','source_system','source_id','import_'] as $blocked)if(str_contains($key,$blocked))return true;
        return in_array($key,['metadata','internal_notes'],true);
    }
}
