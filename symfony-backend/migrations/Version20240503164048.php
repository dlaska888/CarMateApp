<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240503164048 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE car DROP CONSTRAINT FK_773DE69DA76ED395');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT FK_773DE69DA76ED395 FOREIGN KEY (user_id) REFERENCES car_mate_user (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car_photo DROP CONSTRAINT FK_CB1C01CFC3C6F69F');
        $this->addSql('ALTER TABLE car_photo ADD CONSTRAINT FK_CB1C01CFC3C6F69F FOREIGN KEY (car_id) REFERENCES car (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE maintenance DROP CONSTRAINT FK_2F84F8E9C3C6F69F');
        $this->addSql('ALTER TABLE maintenance ADD CONSTRAINT FK_2F84F8E9C3C6F69F FOREIGN KEY (car_id) REFERENCES car (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE car_photo DROP CONSTRAINT fk_cb1c01cfc3c6f69f');
        $this->addSql('ALTER TABLE car_photo ADD CONSTRAINT fk_cb1c01cfc3c6f69f FOREIGN KEY (car_id) REFERENCES car (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE maintenance DROP CONSTRAINT fk_2f84f8e9c3c6f69f');
        $this->addSql('ALTER TABLE maintenance ADD CONSTRAINT fk_2f84f8e9c3c6f69f FOREIGN KEY (car_id) REFERENCES car (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car DROP CONSTRAINT fk_773de69da76ed395');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT fk_773de69da76ed395 FOREIGN KEY (user_id) REFERENCES car_mate_user (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }
}
