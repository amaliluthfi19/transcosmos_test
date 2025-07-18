# Quran Audio Player App

A simple application that allows users to listen to Quranic surahs using the Quran API from open-api.my.id.

## Features

- Browse and search through all 114 surahs of the Quran
- Play audio recitations of complete surahs
- View surah details including name, translation, and number of verses
- Clean and intuitive user interface

## API Reference

This project uses the Quran API from [open-api.my.id](https://open-api.my.id/quran)

### API Endpoints

- Get list of all surahs: `GET /quran`
- Get specific surah details: `GET /quran/{surah_number}`
- Get audio recitation: `GET /quran/audio/{surah_number}`

## Installation

1. Clone the repository

