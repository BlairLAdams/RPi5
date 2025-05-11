#!/bin/bash
# addDmbokBreadcrumbs.sh — Prepends a breadcrumb header to each DMBOK section page

sections=(
  "01_governance"
  "02_architecture"
  "03_modeling"
  "04_storage"
  "05_security"
  "06_integration"
  "07_content"
  "08_masterdata"
  "09_warehousing"
  "10_metadata"
  "11_quality"
)

titles=(
  "Data Governance"
  "Data Architecture"
  "Data Modeling and Design"
  "Data Storage and Operations"
  "Data Security"
  "Data Integration and Interoperability"
  "Document and Content Management"
  "Reference and Master Data"
  "Data Warehousing and Business Intelligence"
  "Metadata Management"
  "Data Quality"
)

cd ~/scr/mkdocs/docs || exit 1

for i in "${!sections[@]}"; do
  file="${sections[i]}/index.md"
  tmp="${file}.tmp"
  breadcrumb="*Home > DMBOK > ${titles[i]}*"

  # Remove existing breadcrumb if present
  sed "/^\\*Home > DMBOK/d" "$file" > "$tmp"

  # Insert breadcrumb at the top
  echo -e "${breadcrumb}\n" | cat - "$tmp" > "$file"
  rm "$tmp"
done

echo "✅ Breadcrumb headers added to all DMBOK index.md files."
