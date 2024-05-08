<?php

namespace App\Dto\Car;

use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Uid\Uuid;

class SetCurrentPhotoIdDto
{
    #[Assert\NotBlank]
    public ?Uuid $photoId = null;
}