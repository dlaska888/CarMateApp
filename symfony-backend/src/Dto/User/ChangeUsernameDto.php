<?php

namespace App\Dto\User;

use Symfony\Component\Validator\Constraints as Assert;

class ChangeUsernameDto
{
    #[Assert\NotBlank]
    #[Assert\Length(min: 3, max: 30)]
    #[Assert\Regex(pattern: '/^[a-zA-Z0-9_]+$/', message: 'Only letters, numbers and underscores are allowed')]
    public ?string $username = null;
    
    #[Assert\NotBlank]
    #[Assert\Length(min: 6, max: 128)]
    public ?string $password = null;
}