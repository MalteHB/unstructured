#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"/.. || exit 1

PYTHONPATH=. ./unstructured/ingest/main.py \
    --metadata-exclude filename,file_directory,metadata.data_source.date_processed \
    --gitlab-url https://gitlab.com/gitlab-com/content-sites/docsy-gitlab \
    --git-file-glob '*.md,*.txt' \
    --structured-output-dir gitlab-ingest-output \
    --git-branch 'v0.0.7' \
    --partition-strategy hi_res \
    --download-dir files-ingest-download/gitlab \
    --preserve-downloads \
    --verbose

set +e

if [ "$(find 'gitlab-ingest-output' -type f -printf '.' | wc -c)" != 2 ]; then
   echo
   echo "2 files should have been created."
   exit 1
fi
