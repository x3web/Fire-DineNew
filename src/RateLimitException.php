<?php
declare(strict_types=1);

namespace FireDine;

use DomainException;

final class RateLimitException extends DomainException
{
    public function __construct(string $message = 'Too many requests. Please try again later.', public readonly int $retryAfter = 60)
    {
        parent::__construct($message);
    }
}
