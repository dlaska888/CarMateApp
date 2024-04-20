<?php

namespace App\Dto\Security;

use Symfony\Component\Validator\Constraints as Assert;

class UserRegisterDto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\Length(min: 3, max: 30)]
        #[Assert\Regex(pattern: '/^[a-zA-Z0-9_]+$/', message: 'Only letters, numbers and underscores are allowed')]
        private ?string $username = null,
        
        #[Assert\NotBlank]
        #[Assert\Email]
        #[Assert\Length(max: 180)]
        private ?string $email = null,

        #[Assert\NotBlank]
        #[Assert\Length(min: 6, max: 128)]
        private ?string $password = null,
        
        #[Assert\NotBlank]
        #[Assert\EqualTo(propertyPath: 'password')]
        private ?string $passwordConfirm = null
    ) {
    }

    public function getUsername(): ?string
    {
        return $this->username;
    }

    public function setUsername(?string $username): void
    {
        $this->username = $username;
    }

    public function getEmail(): ?string
    {
        return $this->email;
    }

    public function setEmail(string $email): void
    {
        $this->email = $email;
    }

    public function getPassword(): ?string
    {
        return $this->password;
    }

    public function setPassword(string $password): void
    {
        $this->password = $password;
    }

    public function getPasswordConfirm(): ?string
    {
        return $this->passwordConfirm;
    }

    public function setPasswordConfirm(?string $passwordConfirm): void
    {
        $this->passwordConfirm = $passwordConfirm;
    }
}
