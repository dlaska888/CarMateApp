<?php

namespace App\Dto\Car;

use App\Entity\Car;
use DateTimeInterface;
use Symfony\Component\Validator\Constraints as Assert;

class CreateCarDto
{
    #[Assert\NotBlank]
    #[Assert\Length(min: 2, max: 50)]
    public ?string $name = null;

    #[Assert\Length(max: 255)]
    public ?string $model = null;

    #[Assert\Length(max: 255)]
    public ?string $brand = null;

    #[Assert\PositiveOrZero]
    public ?float $displacement = null;

    #[Assert\Type(type: 'DateTimeInterface')]
    public ?DateTimeInterface $productionDate = null;

    #[Assert\PositiveOrZero]
    public ?int $mileage = null;

    #[Assert\Type(type: 'DateTimeInterface')]
    public ?DateTimeInterface $purchaseDate = null;

    #[Assert\Length(min: 6, max: 8)]
    public ?string $plate = null;

    #[Assert\Length(min: 17, max: 17)]
    public ?string $vin = null;

}