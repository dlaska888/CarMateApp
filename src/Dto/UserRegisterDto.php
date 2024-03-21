<?php

namespace App\Dto;

use Symfony\Component\Validator\Constraints as Assert;

class UserRegisterDto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\Email]
        private ?string $email = null,

        #[Assert\NotBlank]
        #[Assert\Length(min: 6, max: 255)]
        private ?string $password = null
    ) {
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
}
