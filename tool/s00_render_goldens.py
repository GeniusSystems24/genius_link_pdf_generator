#!/usr/bin/env python3
"""Render captured S00 PDFs to reviewable PNG candidates.

Requires PyMuPDF (`fitz`) to already be installed. This tool never installs
Python packages. Use --accept only after visual review.
"""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--project', type=Path, default=Path.cwd())
    parser.add_argument('--accept', action='store_true')
    parser.add_argument('--scale', type=float, default=2.0)
    args = parser.parse_args()

    root = args.project.resolve()
    generated = root / 'test/sprints/s00/baselines/generated'
    candidates = root / 'test/sprints/s00/goldens/candidates'
    accepted = root / 'test/sprints/s00/goldens/accepted'

    try:
        import fitz  # type: ignore
    except ImportError:
        raise SystemExit(
            'PyMuPDF is not installed. Install it in your own development '
            'environment before rendering S00 goldens.'
        )

    pdfs = sorted(generated.glob('*.pdf'))
    if not pdfs:
        raise SystemExit(
            f'No captured PDFs found in {generated}. Capture S00 PDFs first.'
        )

    candidates.mkdir(parents=True, exist_ok=True)
    for old in candidates.glob('s00__*.png'):
        old.unlink()

    matrix = fitz.Matrix(args.scale, args.scale)
    rendered = []
    for pdf in pdfs:
        doc = fitz.open(pdf)
        try:
            for index, page in enumerate(doc):
                output = candidates / f'{pdf.stem}__p{index + 1:02d}.png'
                page.get_pixmap(matrix=matrix, alpha=False).save(output)
                rendered.append(output)
        finally:
            doc.close()

    print(f'Rendered {len(rendered)} page(s) to {candidates}')
    if args.accept:
        accepted.mkdir(parents=True, exist_ok=True)
        for old in accepted.glob('s00__*.png'):
            old.unlink()
        for image in rendered:
            shutil.copy2(image, accepted / image.name)
        print(f'Accepted {len(rendered)} reviewed page(s) into {accepted}')
    else:
        print('Candidates were not accepted. Review them, then rerun with --accept.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
