<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240410200310 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SEQUENCE refresh_tokens_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE TABLE car (id UUID NOT NULL, user_id UUID NOT NULL, photo_id UUID DEFAULT NULL, name VARCHAR(50) NOT NULL, model VARCHAR(255) DEFAULT NULL, brand VARCHAR(255) DEFAULT NULL, displacement DOUBLE PRECISION DEFAULT NULL, production_date TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, mileage INT DEFAULT NULL, purchase_date TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, plate VARCHAR(255) DEFAULT NULL, vin VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_773DE69DA76ED395 ON car (user_id)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_773DE69D7E9E4C8C ON car (photo_id)');
        $this->addSql('COMMENT ON COLUMN car.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN car.user_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN car.photo_id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE car_mate_user (id UUID NOT NULL, photo_id UUID DEFAULT NULL, username VARCHAR(30) NOT NULL, email VARCHAR(180) NOT NULL, roles JSON NOT NULL, password VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_60C1BCA7E9E4C8C ON car_mate_user (photo_id)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_USERNAME ON car_mate_user (username)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_EMAIL ON car_mate_user (email)');
        $this->addSql('COMMENT ON COLUMN car_mate_user.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN car_mate_user.photo_id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE file (id UUID NOT NULL, name VARCHAR(255) NOT NULL, path VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('COMMENT ON COLUMN file.id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE maintenance (id UUID NOT NULL, car_id UUID NOT NULL, name VARCHAR(50) NOT NULL, description VARCHAR(255) DEFAULT NULL, due_mileage INT DEFAULT NULL, due_date TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, cost NUMERIC(10, 0) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_2F84F8E9C3C6F69F ON maintenance (car_id)');
        $this->addSql('COMMENT ON COLUMN maintenance.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN maintenance.car_id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE refresh_tokens (id INT NOT NULL, refresh_token VARCHAR(128) NOT NULL, username VARCHAR(255) NOT NULL, valid TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_9BACE7E1C74F2195 ON refresh_tokens (refresh_token)');
        $this->addSql('CREATE TABLE messenger_messages (id BIGSERIAL NOT NULL, body TEXT NOT NULL, headers TEXT NOT NULL, queue_name VARCHAR(190) NOT NULL, created_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, available_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, delivered_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_75EA56E0FB7336F0 ON messenger_messages (queue_name)');
        $this->addSql('CREATE INDEX IDX_75EA56E0E3BD61CE ON messenger_messages (available_at)');
        $this->addSql('CREATE INDEX IDX_75EA56E016BA31DB ON messenger_messages (delivered_at)');
        $this->addSql('COMMENT ON COLUMN messenger_messages.created_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('COMMENT ON COLUMN messenger_messages.available_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('COMMENT ON COLUMN messenger_messages.delivered_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('CREATE OR REPLACE FUNCTION notify_messenger_messages() RETURNS TRIGGER AS $$
            BEGIN
                PERFORM pg_notify(\'messenger_messages\', NEW.queue_name::text);
                RETURN NEW;
            END;
        $$ LANGUAGE plpgsql;');
        $this->addSql('DROP TRIGGER IF EXISTS notify_trigger ON messenger_messages;');
        $this->addSql('CREATE TRIGGER notify_trigger AFTER INSERT OR UPDATE ON messenger_messages FOR EACH ROW EXECUTE PROCEDURE notify_messenger_messages();');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT FK_773DE69DA76ED395 FOREIGN KEY (user_id) REFERENCES car_mate_user (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car ADD CONSTRAINT FK_773DE69D7E9E4C8C FOREIGN KEY (photo_id) REFERENCES file (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE car_mate_user ADD CONSTRAINT FK_60C1BCA7E9E4C8C FOREIGN KEY (photo_id) REFERENCES file (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE maintenance ADD CONSTRAINT FK_2F84F8E9C3C6F69F FOREIGN KEY (car_id) REFERENCES car (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('DROP SEQUENCE refresh_tokens_id_seq CASCADE');
        $this->addSql('ALTER TABLE car DROP CONSTRAINT FK_773DE69DA76ED395');
        $this->addSql('ALTER TABLE car DROP CONSTRAINT FK_773DE69D7E9E4C8C');
        $this->addSql('ALTER TABLE car_mate_user DROP CONSTRAINT FK_60C1BCA7E9E4C8C');
        $this->addSql('ALTER TABLE maintenance DROP CONSTRAINT FK_2F84F8E9C3C6F69F');
        $this->addSql('DROP TABLE car');
        $this->addSql('DROP TABLE car_mate_user');
        $this->addSql('DROP TABLE file');
        $this->addSql('DROP TABLE maintenance');
        $this->addSql('DROP TABLE refresh_tokens');
        $this->addSql('DROP TABLE messenger_messages');
    }
}
