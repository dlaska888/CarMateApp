<?php

namespace App\Dto\Security;

class GetTokenAndRefreshDto
{
    public ?string $token;
    public ?string $refreshToken;
}