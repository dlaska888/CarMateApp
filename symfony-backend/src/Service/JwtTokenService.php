<?php

namespace App\Service;

use App\Dto\Security\GetTokenAndRefreshDto;
use App\Entity\CarMateUser;
use Gesdinet\JWTRefreshTokenBundle\Generator\RefreshTokenGeneratorInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;
use Symfony\Component\DependencyInjection\ParameterBag\ContainerBagInterface;

class JwtTokenService
{
    public function __construct(
        private readonly JWTTokenManagerInterface       $JWTManager,
        private readonly RefreshTokenGeneratorInterface $refreshTokenGenerator,
        private readonly ContainerBagInterface          $containerBag
    )
    {
    }


    function GenerateTokenAndRefreshForUser(CarMateUser $user): GetTokenAndRefreshDto
    {
        $result = new GetTokenAndRefreshDto();
        $result->token = $this->JWTManager->create($user);
        $result->refreshToken = $this->refreshTokenGenerator->createForUserWithTtl($user, $this->containerBag->get('refresh_token_ttl'));
        return $result;
    }
}