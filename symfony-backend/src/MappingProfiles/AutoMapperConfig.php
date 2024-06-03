<?php

namespace App\MappingProfiles;

use App\Dto\Car\GetCarDto;
use App\Dto\Maintenance\GetMaintenanceDto;
use App\Dto\Security\UserRegisterDto;
use App\Dto\User\GetUserDto;
use App\Entity\Car;
use App\Entity\CarMateUser;
use AutoMapperPlus\AutoMapperInterface;
use AutoMapperPlus\AutoMapperPlusBundle\AutoMapperConfiguratorInterface;
use AutoMapperPlus\Configuration\AutoMapperConfigInterface;
use Ramsey\Uuid\Uuid;

class AutoMapperConfig implements AutoMapperConfiguratorInterface
{
    public function configure(AutoMapperConfigInterface $config): void
    {
        $config->registerMapping(Car::class, GetCarDto::class)
            ->dontSkipConstructor()
            ->forMember('currentPhotoId', function (Car $car) {
                return $car->getCurrentPhoto()?->getId();
            })
            ->forMember('maintenances', function (Car $car, AutoMapperInterface $autoMapper) {
                return $autoMapper->mapMultiple($car->getMaintenances(), GetMaintenanceDto::class);
            })
            ->forMember('photosIds', function (Car $car) {
                return $car->getPhotos()->map(fn($photo) => $photo?->getId())->toArray();
            });

        $config->registerMapping(CarMateUser::class, GetUserDto::class)
            ->forMember('roles', fn(CarMateUser $user) => $user->getRoles())
            ->forMember('photoId', fn(CarMateUser $user) => $user->getPhoto()?->getId())
            ->forMember('isGoogleAuth', fn(CarMateUser $user) => $user->getGoogle() !== null);

        $config->registerMapping(UserRegisterDto::class, CarMateUser::class)
            ->forMember('confirmationToken', fn() => Uuid::uuid6()->toString());
        
    }
}