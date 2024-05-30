<?php

namespace App\Dto\Security;

use Symfony\Component\Validator\Constraints as Assert;

class GoogleLoginDto
{
    #[Assert\NotBlank]
    public ?string $idToken = null;
}