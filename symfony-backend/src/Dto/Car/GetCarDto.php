<?php

namespace App\Dto\Car;

use DateTimeInterface;
use Symfony\Component\Uid\Uuid;

class GetCarDto
{
    public ?Uuid $id;

    public ?string $name;

    public ?string $model;

    public ?string $brand;

    public ?float $displacement;

    public ?DateTimeInterface $productionDate;

    public ?int $mileage;

    public ?DateTimeInterface $purchaseDate;

    public ?string $plate;

    public ?string $VIN;

    public array $maintenances;
}
