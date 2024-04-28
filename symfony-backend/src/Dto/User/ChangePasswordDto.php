<?php

namespace App\Dto\User;

use Symfony\Component\Validator\Constraints as Assert;

class ChangePasswordDto
{
    #[Assert\NotBlank]
    #[Assert\Length(min: 6, max: 128)]
    public ?string $newPassword = null;

    #[Assert\NotBlank]
    #[Assert\EqualTo(propertyPath: 'newPassword', message: 'Passwords do not match')]
    public ?string $newPasswordConfirm = null;

    #[Assert\NotBlank]
    #[Assert\Length(min: 6, max: 128)]
    public ?string $password = null;
}