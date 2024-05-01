<?php

namespace App\Dto;

use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\Validator\Constraints as Assert;

class PhotoUploadDto
{
    #[Assert\NotBlank(message: 'No photo uploaded')]
    #[Assert\Image(maxSize: '1m')]
    public ?UploadedFile $photo = null;
}
