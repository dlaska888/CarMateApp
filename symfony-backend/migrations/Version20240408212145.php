<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240408212145 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE car (id SERIAL NOT NULL, user_id INT NOT NULL, photo_id INT DEFAULT NULL, name VARCHAR(255) NOT NULL, model VARCHAR(255) DEFAULT NULL, brand VARCHAR(255) DEFAULT NULL, displacement INT DEFAULT NULL, production_date DATE DEFAULT NULL, mileage INT DEFAULT NULL, purchase_date DATE DEFAULT NULL, plate VARCHAR(255) DEFAULT NULL, vin VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_773DE69DA76ED395 ON car (user_id)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_773DE69D7E9E4C8C ON car (photo_id)');
        $this->addSql('CREATE TABLE custom_work (id SERIAL NOT NULL, car_id INT NOT NULL, name VARCHAR(255) NOT NULL, description VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_5238A07DC3C6F69F ON custom_work (car_id)');
        $this->addSql('CREATE TABLE file (id SERIAL NOT NULL, name VARCHAR(255) NOT NULL, path VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE TABLE maintenance (id SERIAL NOT NULL, car_id INT NOT NULL, name VARCHAR(255) NOT NULL, description VARCHAR(255) DEFAULT NULL, due_mileage INT DEFAULT NULL, due_date TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_2F84F8E9C3C6F69F ON maintenance (car_id)');
        $this->addSql('CREATE TABLE maintenance_work (id SERIAL NOT NULL, maintenance_id INT NOT NULL, date VARCHAR(255) NOT NULL, cost DOUBLE PRECISION NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_9C5D084CF6C202BC ON maintenance_work (maintenance_id)');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT FK_773DE69DA76ED395 FOREIGN KEY (user_id) REFERENCES car_mate_user (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT FK_773DE69D7E9E4C8C FOREIGN KEY (photo_id) REFERENCES file (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE custom_work ADD CONSTRAINT FK_5238A07DC3C6F69F FOREIGN KEY (car_id) REFERENCES car (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE maintenance ADD CONSTRAINT FK_2F84F8E9C3C6F69F FOREIGN KEY (car_id) REFERENCES car (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE maintenance_work ADD CONSTRAINT FK_9C5D084CF6C202BC FOREIGN KEY (maintenance_id) REFERENCES maintenance (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car_mate_user ADD photo_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE car_mate_user ADD username VARCHAR(30) NOT NULL');
        $this->addSql('ALTER TABLE car_mate_user ADD CONSTRAINT FK_60C1BCA7E9E4C8C FOREIGN KEY (photo_id) REFERENCES file (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_60C1BCA7E9E4C8C ON car_mate_user (photo_id)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_USERNAME ON car_mate_user (username)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE car_mate_user DROP CONSTRAINT FK_60C1BCA7E9E4C8C');
        $this->addSql('ALTER TABLE car DROP CONSTRAINT FK_773DE69DA76ED395');
        $this->addSql('ALTER TABLE car DROP CONSTRAINT FK_773DE69D7E9E4C8C');
        $this->addSql('ALTER TABLE custom_work DROP CONSTRAINT FK_5238A07DC3C6F69F');
        $this->addSql('ALTER TABLE maintenance DROP CONSTRAINT FK_2F84F8E9C3C6F69F');
        $this->addSql('ALTER TABLE maintenance_work DROP CONSTRAINT FK_9C5D084CF6C202BC');
        $this->addSql('DROP TABLE car');
        $this->addSql('DROP TABLE custom_work');
        $this->addSql('DROP TABLE file');
        $this->addSql('DROP TABLE maintenance');
        $this->addSql('DROP TABLE maintenance_work');
        $this->addSql('DROP INDEX UNIQ_60C1BCA7E9E4C8C');
        $this->addSql('DROP INDEX UNIQ_IDENTIFIER_USERNAME');
        $this->addSql('ALTER TABLE car_mate_user DROP photo_id');
        $this->addSql('ALTER TABLE car_mate_user DROP username');
    }
}
