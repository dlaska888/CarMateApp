<?php

namespace App\Service;

use Symfony\Component\DependencyInjection\ParameterBag\ContainerBagInterface;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Component\Mime\Address;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class EmailService
{
    public function __construct(
        private readonly MailerInterface       $mailer,
        private readonly ContainerBagInterface $params,
        private readonly UrlGeneratorInterface $urlGenerator
    )
    {
    }

    public function sendConfirmationEmail(string $to, string $name, string $confirmationLink): void
    {
        $confirmationLink = $this->urlGenerator->generate('api_confirm_email', ['token' => $confirmationLink], UrlGeneratorInterface::ABSOLUTE_URL);

        $email = (new TemplatedEmail())
            ->from(new Address($this->params->get('system_mail'), $this->params->get('system_name')))
            ->to(new Address($to))
            ->subject('Your registration was successful!')
            ->htmlTemplate('email/email.html.twig')
            ->context([
                'name' => $name,
                'confirmationLink' => $confirmationLink,
            ]);

        $this->mailer->send($email);
    }
}
