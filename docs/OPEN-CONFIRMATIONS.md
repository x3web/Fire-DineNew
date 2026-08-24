# Fire & Dine Open Confirmations

Version: Unreleased verification build  
Date: 23 August 2026  
Status: 15 pending items, all handled safely without misleading public pricing.

The canonical editable register is the private `product_confirmations` database table. Only authorised administrators can view or update it at `/admin/confirmations`. Every status/value change creates an audit-history row.

| Confirmation | Product | Provisional value | Current public handling | Blocks purchasing | Price update | Content update | Image required | Action after confirmation |
|---|---|---|---|---|---|---|---|---|
| Premium DIY Grande dimension | Premium DIY Range | 1,050 mm front-to-back | Show 1,050 mm and “Please confirm final base dimensions with Fire & Dine before construction.” | No | No | Yes | No | Replace the measurement/note if confirmed value differs; otherwise close the item. |
| Premium Mobile model names | Premium Mobile Range | Piccolo, Grande, Superior | Show only the current guide names. | No | No | Yes | No | Update names, attributes and all nine variation labels only if Fire & Dine confirms a change. |
| Mobile Countertop floor wording | Mobile Countertop Oven | “Firebrick floor” from voice note | Show “Heat-retaining oven floor.” | No | No | Yes | No | Restore exact material wording only after confirmation. |
| Steel Oven colours | Steel Oven Range | Canary Yellow, Signal Red, Grey/Silver, Black | Show these four colours; availability confirmed during quotation. | No | No | Yes | No | Confirm final list; do not add blue/olive or surcharges without evidence. |
| Textured finish colours | General oven finishes | Seven provisional swatch names | Show only “Textured finish available — current colours confirmed during quotation.” | No | No | Yes | No | Publish only the confirmed colour subset. |
| Textured finish pricing | Applicable DIY/Counter Top ranges | R1,100 / R1,200 / R1,500 mapping unknown | Request Quote; NULL numeric adjustment. | No | Yes | Yes | No | Map confirmed amount by product/model and add server-tested pricing. |
| Coastal Kit price | Applicable optional ranges | Conflicting free/paid sources; old R1,955 rejected | Request Quote; never free or R0. Omitted for coastal-ready standard products. | No | Yes | Yes | No | Add confirmed product-specific price or included state. |
| Premium Pre-Fabricato flue material | Premium Pre-Fabricato Range | Brushed flue pipe; metal unknown | Show “Brushed flue pipe.” | No | No | Yes | No | Add the confirmed metal type if supplied. |
| Premium Mobile trolley anomaly | Premium Mobile Range | Component values have an unusual Medium/Large progression | Keep the nine complete guide prices exactly. | No | Yes | No | Adjust only affected complete prices when Fire & Dine supplies corrected values. |
| X-Small crate | General delivery | R850; assignment/dimensions unknown | Delivery and crating quoted separately. | No | Yes | Yes | No | Assign only after product and dimensions are confirmed. |
| Rib Rack duplication | Product 83 | Product 80 R620 / product 83 R580 | Product 80 active; product 83 archived/hidden. | No | Yes | Yes | No | Merge permanently only with approved data-retention plan, or distinguish confirmed size. |
| Flatpack name/specifications | Flatpack Braai | Tassie/Flatpack; dimensions, weight and grid unknown | Keep Flatpack Braai; omit unknown specs, grid and custom stainless claim. | No | No | Yes | No | Update the name/specs after written confirmation. |
| Smooth-colour photographs | General finishes | No clearly named approved swatch set found | Use only approved supplied media/fallback. | No | No | No | Yes | Upload and map the approved smooth-colour set. |
| Textured-swatch photographs | General finishes | No clearly named approved swatch set found | Do not generate or substitute. | No | No | No | Yes | Upload approved swatches after the final colour list is confirmed. |
| Canvas Covers photograph | Canvas Covers | No approved product image found | Official Fire & Dine logo fallback. | No | No | No | Yes | Replace fallback with an approved Canvas Cover photograph. |

Brick-face and mosaic images exist in the supplied website assets. They remain preserved but are not automatically reassigned as product imagery without an approved product-to-image mapping.
