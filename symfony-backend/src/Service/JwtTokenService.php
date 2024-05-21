<?php

namespace App\Service;

use App\Dto\Security\GetTokenAndRefreshDto;
use App\Entity\CarMateUser;
use Gesdinet\JWTRefreshTokenBundle\Generator\RefreshTokenGeneratorInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;

class JwtTokenService
{
    private readonly int $refreshTtl;

    public function __construct(
        private readonly JWTTokenManagerInterface       $JWTManager,
        private readonly RefreshTokenGeneratorInterface $refreshTokenGenerator,
    )
    {
        $this->refreshTtl = getenv('REFRESH_TOKEN_TTL');
    }


    function GenerateTokenAndRefreshForUser(CarMateUser $user): GetTokenAndRefreshDto
    {
        $result = new GetTokenAndRefreshDto();
        $result->token = $this->JWTManager->create($user);
        $result->refreshToken = $this->refreshTokenGenerator->createForUserWithTtl($user, $this->refreshTtl);
        return $result;
    }
}