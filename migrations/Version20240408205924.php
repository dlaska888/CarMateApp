<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240408205924 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE car ALTER model DROP NOT NULL');
        $this->addSql('ALTER TABLE car ALTER brand DROP NOT NULL');
        $this->addSql('ALTER TABLE car ALTER displacement DROP NOT NULL');
        $this->addSql('ALTER TABLE car ALTER production_date DROP NOT NULL');
        $this->addSql('ALTER TABLE car ALTER mileage DROP NOT NULL');
        $this->addSql('ALTER TABLE car ALTER purchase_date DROP NOT NULL');
        $this->addSql('ALTER TABLE car ALTER plate DROP NOT NULL');
        $this->addSql('ALTER TABLE car ALTER vin DROP NOT NULL');
        $this->addSql('ALTER TABLE custom_work ALTER description DROP NOT NULL');
        $this->addSql('ALTER TABLE maintenance ALTER description DROP NOT NULL');
        $this->addSql('ALTER TABLE maintenance ALTER due_mileage DROP NOT NULL');
        $this->addSql('ALTER TABLE maintenance ALTER due_date DROP NOT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE car ALTER model SET NOT NULL');
        $this->addSql('ALTER TABLE car ALTER brand SET NOT NULL');
        $this->addSql('ALTER TABLE car ALTER displacement SET NOT NULL');
        $this->addSql('ALTER TABLE car ALTER production_date SET NOT NULL');
        $this->addSql('ALTER TABLE car ALTER mileage SET NOT NULL');
        $this->addSql('ALTER TABLE car ALTER purchase_date SET NOT NULL');
        $this->addSql('ALTER TABLE car ALTER plate SET NOT NULL');
        $this->addSql('ALTER TABLE car ALTER vin SET NOT NULL');
        $this->addSql('ALTER TABLE maintenance ALTER description SET NOT NULL');
        $this->addSql('ALTER TABLE maintenance ALTER due_mileage SET NOT NULL');
        $this->addSql('ALTER TABLE maintenance ALTER due_date SET NOT NULL');
        $this->addSql('ALTER TABLE custom_work ALTER description SET NOT NULL');
    }
}
