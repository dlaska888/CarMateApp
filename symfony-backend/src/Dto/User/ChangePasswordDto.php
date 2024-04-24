<?php

namespace App\Dto\User;

use Symfony\Component\Validator\Constraints as Assert;

class ChangePasswordDto
{
    #[Assert\NotBlank]
    #[Assert\Length(min: 6, max: 128)]
    public ?string $newPassword;

    #[Assert\NotBlank]
    #[Assert\EqualTo(propertyPath: 'newPassword', message: 'Passwords do not match')]
    public ?string $newPasswordConfirm;

    #[Assert\NotBlank]
    #[Assert\Length(min: 6, max: 128)]
    public ?string $password;
}