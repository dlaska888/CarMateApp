<?php

namespace App\Dto\Security;

class GetTokenAndRefreshDto
{
    public ?string $token = null;
    public ?string $refreshToken = null;
}