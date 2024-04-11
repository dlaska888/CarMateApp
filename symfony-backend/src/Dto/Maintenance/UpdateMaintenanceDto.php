<?php

namespace App\Dto\Maintenance;

use DateTimeInterface;
use Symfony\Component\Validator\Constraints as Assert;

class UpdateMaintenanceDto
{
    #[Assert\Length(min: 2, max: 50)]
    private ?string $name;

    #[Assert\Length(max: 255)]
    private ?string $description;

    #[Assert\PositiveOrZero]
    private ?int $dueMileage;

    #[Assert\DateTime]
    private ?DateTimeInterface $dueDate;

    #[Assert\PositiveOrZero]
    private ?string $cost;

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(?string $name): void
    {
        $this->name = $name;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): void
    {
        $this->description = $description;
    }

    public function getDueMileage(): ?int
    {
        return $this->dueMileage;
    }

    public function setDueMileage(?int $dueMileage): void
    {
        $this->dueMileage = $dueMileage;
    }

    public function getDueDate(): ?DateTimeInterface
    {
        return $this->dueDate;
    }

    public function setDueDate(?DateTimeInterface $dueDate): void
    {
        $this->dueDate = $dueDate;
    }

    public function getCost(): ?string
    {
        return $this->cost;
    }

    public function setCost(?string $cost): void
    {
        $this->cost = $cost;
    }
}