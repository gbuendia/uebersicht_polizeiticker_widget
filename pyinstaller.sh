#!/bin/sh

pyinstaller --distpath ./ --workpath ./pyinstaller-build --clean --onefile getnews.py