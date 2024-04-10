<?php

namespace App\Dto\Car;

use App\Entity\Car;
use DateTimeInterface;
use Symfony\Component\Validator\Constraints as Assert;

class UpdateCarDto
{
    #[Assert\Length(min: 2, max: 50)]
    private ?string $name;

    #[Assert\Length(max: 255)]
    private ?string $model;

    #[Assert\Length(max: 255)]
    private ?string $brand;

    #[Assert\PositiveOrZero]
    private ?float $displacement;

    #[Assert\DateTime]
    private ?DateTimeInterface $productionDate;

    #[Assert\PositiveOrZero]
    private ?int $mileage;

    #[Assert\DateTime]
    private ?DateTimeInterface $purchaseDate;

    #[Assert\Length(min: 6, max: 8)]
    private ?string $plate;

    #[Assert\Length(min: 17, max: 17)]
    private ?string $VIN;

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(?string $name): void
    {
        $this->name = $name;
    }

    public function getModel(): ?string
    {
        return $this->model;
    }

    public function setModel(?string $model): void
    {
        $this->model = $model;
    }

    public function getBrand(): ?string
    {
        return $this->brand;
    }

    public function setBrand(?string $brand): void
    {
        $this->brand = $brand;
    }

    public function getDisplacement(): ?float
    {
        return $this->displacement;
    }

    public function setDisplacement(?float $displacement): void
    {
        $this->displacement = $displacement;
    }

    public function getProductionDate(): ?DateTimeInterface
    {
        return $this->productionDate;
    }

    public function setProductionDate(?DateTimeInterface $productionDate): void
    {
        $this->productionDate = $productionDate;
    }

    public function getMileage(): ?int
    {
        return $this->mileage;
    }

    public function setMileage(?int $mileage): void
    {
        $this->mileage = $mileage;
    }

    public function getPurchaseDate(): ?DateTimeInterface
    {
        return $this->purchaseDate;
    }

    public function setPurchaseDate(?DateTimeInterface $purchaseDate): void
    {
        $this->purchaseDate = $purchaseDate;
    }

    public function getPlate(): ?string
    {
        return $this->plate;
    }

    public function setPlate(?string $plate): void
    {
        $this->plate = $plate;
    }

    public function getVIN(): ?string
    {
        return $this->VIN;
    }

    public function setVIN(?string $VIN): void
    {
        $this->VIN = $VIN;
    }
}
