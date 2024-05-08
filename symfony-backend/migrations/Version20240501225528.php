<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240501225528 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE car_photo (id UUID NOT NULL, car_id UUID NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_CB1C01CFC3C6F69F ON car_photo (car_id)');
        $this->addSql('COMMENT ON COLUMN car_photo.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN car_photo.car_id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE user_photo (id UUID NOT NULL, PRIMARY KEY(id))');
        $this->addSql('COMMENT ON COLUMN user_photo.id IS \'(DC2Type:uuid)\'');
        $this->addSql('ALTER TABLE car_photo ADD CONSTRAINT FK_CB1C01CFC3C6F69F FOREIGN KEY (car_id) REFERENCES car (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car_photo ADD CONSTRAINT FK_CB1C01CFBF396750 FOREIGN KEY (id) REFERENCES file (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE user_photo ADD CONSTRAINT FK_F6757F40BF396750 FOREIGN KEY (id) REFERENCES file (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car DROP CONSTRAINT fk_773de69d7e9e4c8c');
        $this->addSql('DROP INDEX uniq_773de69d7e9e4c8c');
        $this->addSql('ALTER TABLE car RENAME COLUMN photo_id TO current_photo_id');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT FK_773DE69DE3E636A6 FOREIGN KEY (current_photo_id) REFERENCES car_photo (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_773DE69DE3E636A6 ON car (current_photo_id)');
        $this->addSql('ALTER TABLE car_mate_user DROP CONSTRAINT FK_60C1BCA7E9E4C8C');
        $this->addSql('ALTER TABLE car_mate_user ADD CONSTRAINT FK_60C1BCA7E9E4C8C FOREIGN KEY (photo_id) REFERENCES user_photo (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE file ADD discr VARCHAR(255) NOT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE car DROP CONSTRAINT FK_773DE69DE3E636A6');
        $this->addSql('ALTER TABLE car_mate_user DROP CONSTRAINT FK_60C1BCA7E9E4C8C');
        $this->addSql('ALTER TABLE car_photo DROP CONSTRAINT FK_CB1C01CFC3C6F69F');
        $this->addSql('ALTER TABLE car_photo DROP CONSTRAINT FK_CB1C01CFBF396750');
        $this->addSql('ALTER TABLE user_photo DROP CONSTRAINT FK_F6757F40BF396750');
        $this->addSql('DROP TABLE car_photo');
        $this->addSql('DROP TABLE user_photo');
        $this->addSql('ALTER TABLE car_mate_user DROP CONSTRAINT fk_60c1bca7e9e4c8c');
        $this->addSql('ALTER TABLE car_mate_user ADD CONSTRAINT fk_60c1bca7e9e4c8c FOREIGN KEY (photo_id) REFERENCES file (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('DROP INDEX UNIQ_773DE69DE3E636A6');
        $this->addSql('ALTER TABLE car RENAME COLUMN current_photo_id TO photo_id');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT fk_773de69d7e9e4c8c FOREIGN KEY (photo_id) REFERENCES file (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX uniq_773de69d7e9e4c8c ON car (photo_id)');
        $this->addSql('ALTER TABLE file DROP discr');
    }
}
