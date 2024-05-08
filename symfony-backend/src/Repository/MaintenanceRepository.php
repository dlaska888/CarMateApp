<?php

namespace App\Repository;

use App\Entity\Maintenance;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class MaintenanceRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Maintenance::class);
    }
    
    public function findMaintenancesByDates($carId, $startDate, $endDate)
    {
        return $this->createQueryBuilder('m')
            ->where('m.car = :carId')
            ->andWhere('m.dueDate BETWEEN :startDate AND :endDate')
            ->andWhere('m.cost IS NOT NULL')
            ->orderBy('m.dueDate', 'ASC')
            ->setParameter('carId', $carId)
            ->setParameter('startDate', $startDate)
            ->setParameter('endDate', $endDate)
            ->getQuery()
            ->getResult();
    }
}