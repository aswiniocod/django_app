# Generated by Django 4.2.1 on 2024-12-04 08:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('web', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='testmodel',
            name='designation',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]