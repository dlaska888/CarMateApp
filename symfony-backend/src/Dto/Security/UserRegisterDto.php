<?php

namespace App\Dto\Security;

use Symfony\Component\Validator\Constraints as Assert;

class UserRegisterDto
{
    #[Assert\NotBlank]
    #[Assert\Length(min: 3, max: 30)]
    #[Assert\Regex(pattern: '/^[a-zA-Z0-9_]+$/', message: 'Only letters, numbers and underscores are allowed')]
    public ?string $username = null;

    #[Assert\NotBlank]
    #[Assert\Email]
    #[Assert\Length(max: 180)]
    public ?string $email = null;

    #[Assert\NotBlank]
    #[Assert\Length(min: 6, max: 128)]
    public ?string $password = null;

    #[Assert\NotBlank]
    #[Assert\EqualTo(propertyPath: 'password', message: 'Passwords do not match')]
    public ?string $passwordConfirm = null;
}
