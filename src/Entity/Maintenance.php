<?php

namespace App\Entity;

use App\Repository\MaintenanceRepository;
use DateTimeInterface;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: MaintenanceRepository::class)]
class Maintenance
{
    #[ORM\Id]
    #[ORM\GeneratedValue(strategy: "IDENTITY")]
    #[ORM\Column(type: "integer")]
    private ?int $id = null;

    #[ORM\Column(type: "string", length: 255)]
    private ?string $name = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $description = null;

    #[ORM\Column(type: "integer", nullable: true)]
    private ?int $dueMileage = null;

    #[ORM\Column(type: "datetime", nullable: true)]
    private ?DateTimeInterface $dueDate = null;

    #[ORM\ManyToOne(targetEntity: Car::class, inversedBy: "maintenances")]
    #[ORM\JoinColumn(nullable: false)]
    private ?Car $car;

    #[ORM\OneToMany(targetEntity: MaintenanceWork::class, mappedBy: "maintenance")]
    private Collection $maintenanceWorks;

    public function __construct()
    {
        $this->maintenanceWorks = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(?string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): self
    {
        $this->description = $description;

        return $this;
    }

    public function getDueMileage(): ?int
    {
        return $this->dueMileage;
    }

    public function setDueMileage(?int $dueMileage): self
    {
        $this->dueMileage = $dueMileage;

        return $this;
    }

    public function getDueDate(): ?DateTimeInterface
    {
        return $this->dueDate;
    }

    public function setDueDate(?DateTimeInterface $dueDate): self
    {
        $this->dueDate = $dueDate;

        return $this;
    }

    public function getCar(): ?Car
    {
        return $this->car;
    }

    public function setCar(?Car $car): self
    {
        $this->car = $car;
        return $this;
    }

    public function getMaintenanceWorks(): Collection
    {
        return $this->maintenanceWorks;
    }

    public function addMaintenanceWork(MaintenanceWork $maintenanceWork): self
    {
        if (!$this->maintenanceWorks->contains($maintenanceWork)) {
            $this->maintenanceWorks[] = $maintenanceWork;
            $maintenanceWork->setMaintenance($this);
        }

        return $this;
    }

    public function removeMaintenanceWork(MaintenanceWork $maintenanceWork): self
    {
        if ($this->maintenanceWorks->removeElement($maintenanceWork)) {
            // set the owning side to null (unless already changed)
            if ($maintenanceWork->getMaintenance() === $this) {
                $maintenanceWork->setMaintenance(null);
            }
        }

        return $this;
    }
}
