<?php

namespace App\Dto\Car;

use App\Entity\Car;
use DateTimeInterface;
use Symfony\Component\Validator\Constraints as Assert;

class UpdateCarDto
{
    #[Assert\Length(min: 2, max: 50)]
    public ?string $name;

    #[Assert\Length(max: 255)]
    public ?string $model;

    #[Assert\Length(max: 255)]
    public ?string $brand;

    #[Assert\PositiveOrZero]
    public ?float $displacement;

    #[Assert\Type(type: 'DateTimeInterface')]
    public ?DateTimeInterface $productionDate;

    #[Assert\PositiveOrZero]
    public ?int $mileage;

    #[Assert\Type(type: 'DateTimeInterface')]
    public ?DateTimeInterface $purchaseDate;

    #[Assert\Length(min: 6, max: 8)]
    public ?string $plate;

    #[Assert\Length(min: 17, max: 17)]
    public ?string $VIN;

}
