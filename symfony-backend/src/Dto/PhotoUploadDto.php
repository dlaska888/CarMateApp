<?php

namespace App\Dto;

use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\Validator\Constraints as Assert;

class PhotoUploadDto
{
    #[Assert\NotBlank(message: 'No photo uploaded')]
    #[Assert\Image(maxSize: '1m', mimeTypes: ['image/jpeg', 'image/png', 'image/webp'])]
    public ?UploadedFile $photo;
}
