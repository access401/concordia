# Generated by Django 2.0.8 on 2018-10-02 19:00

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('concordia', '0030_merge_20181002_1350'),
    ]

    operations = [
        migrations.RenameField(
            model_name='transcription',
            old_name='user_id',
            new_name='user',
        ),
        migrations.RenameField(
            model_name='userassettagcollection',
            old_name='user_id',
            new_name='user',
        ),
    ]
