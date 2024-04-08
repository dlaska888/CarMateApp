<?php

namespace App\Entity;

use App\Repository\CarRepository;
use DateTimeInterface;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: CarRepository::class)]
class Car
{
    #[ORM\Id]
    #[ORM\GeneratedValue(strategy: "IDENTITY")]
    #[ORM\Column(type: "integer")]
    private ?int $id = null;

    #[ORM\Column(type: "string", length: 255)]
    private ?string $name = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $model = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $brand = null;

    #[ORM\Column(type: "integer", nullable: true)]
    private ?int $displacement = null;

    #[ORM\Column(type: "date", nullable: true)]
    private ?DateTimeInterface $productionDate = null;

    #[ORM\Column(type: "integer", nullable: true)]
    private ?int $mileage = null;

    #[ORM\Column(type: "date", nullable: true)]
    private ?DateTimeInterface $purchaseDate = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $plate = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $VIN = null;

    #[ORM\ManyToOne(targetEntity: CarMateUser::class, inversedBy: "cars")]
    #[ORM\JoinColumn(nullable: false)]
    private ?CarMateUser $user;

    #[ORM\OneToOne(targetEntity: File::class)]
    #[ORM\JoinColumn(nullable: true)]
    private ?File $photo = null;

    #[ORM\OneToMany(targetEntity: Maintenance::class, mappedBy: "car")]
    private Collection $maintenances;

    #[ORM\OneToMany(targetEntity: CustomWork::class, mappedBy: "car")]
    private Collection $customWorks;

    public function __construct()
    {
        $this->customWorks = new ArrayCollection();
        $this->maintenances = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getModel(): ?string
    {
        return $this->model;
    }

    public function setModel(string $model): self
    {
        $this->model = $model;
        return $this;
    }

    public function getBrand(): ?string
    {
        return $this->brand;
    }

    public function setBrand(string $brand): self
    {
        $this->brand = $brand;
        return $this;
    }

    public function getDisplacement(): ?int
    {
        return $this->displacement;
    }

    public function setDisplacement(int $displacement): self
    {
        $this->displacement = $displacement;
        return $this;
    }

    public function getProductionDate(): ?DateTimeInterface
    {
        return $this->productionDate;
    }

    public function setProductionDate(DateTimeInterface $productionDate): self
    {
        $this->productionDate = $productionDate;
        return $this;
    }

    public function getMileage(): ?int
    {
        return $this->mileage;
    }

    public function setMileage(int $mileage): self
    {
        $this->mileage = $mileage;
        return $this;
    }

    public function getPurchaseDate(): ?DateTimeInterface
    {
        return $this->purchaseDate;
    }

    public function setPurchaseDate(DateTimeInterface $purchaseDate): self
    {
        $this->purchaseDate = $purchaseDate;
        return $this;
    }

    public function getPlate(): ?string
    {
        return $this->plate;
    }

    public function setPlate(string $plate): self
    {
        $this->plate = $plate;
        return $this;
    }

    public function getVIN(): ?string
    {
        return $this->VIN;
    }

    public function setVIN(string $VIN): self
    {
        $this->VIN = $VIN;
        return $this;
    }

    public function getUser(): ?CarMateUser
    {
        return $this->user;
    }

    public function setUser(?CarMateUser $user): self
    {
        $this->user = $user;
        return $this;
    }
    
    public function getPhoto(): ?File
    {
        return $this->photo;
    }

    public function setPhoto(?File $photoId): self
    {
        $this->photo = $photoId;
        return $this;
    }

    public function getMaintenances(): Collection
    {
        return $this->maintenances;
    }

    public function addMaintenance(Maintenance $maintenance): self
    {
        if (!$this->maintenances->contains($maintenance)) {
            $this->maintenances[] = $maintenance;
            $maintenance->setCar($this);
        }

        return $this;
    }

    public function removeMaintenance(Maintenance $maintenance): self
    {
        if ($this->maintenances->removeElement($maintenance)) {
            // set the owning side to null (unless already changed)
            if ($maintenance->getCar() === $this) {
                $maintenance->setCar(null);
            }
        }

        return $this;
    }

    public function getCustomWorks(): Collection
    {
        return $this->customWorks;
    }

    public function addCustomWork(CustomWork $customWork): self
    {
        if (!$this->customWorks->contains($customWork)) {
            $this->customWorks[] = $customWork;
            $customWork->setCar($this);
        }

        return $this;
    }

    public function removeCustomWork(CustomWork $customWork): self
    {
        if ($this->customWorks->removeElement($customWork)) {
            // set the owning side to null (unless already changed)
            if ($customWork->getCar() === $this) {
                $customWork->setCar(null);
            }
        }

        return $this;
    }
}
