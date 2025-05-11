#!/bin/bash
# addDmbokNav.sh — Appends Next/Previous links to DMBOK index.md files

# Ordered list of DMBOK folders
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

  # Remove old footer if it exists
  sed -i '/^---/,$d' "$file"

  echo -e "\n---\n" >> "$file"

  # Previous link
  if [ $i -gt 0 ]; then
    prev="${sections[i-1]}"
    prev_title="${titles[i-1]}"
    echo "**← Previous:** [${prev_title}](../${prev}/index.md)" >> "$file"
  fi

  # Next link
  if [ $i -lt $((${#sections[@]} - 1)) ]; then
    next="${sections[i+1]}"
    next_title="${titles[i+1]}"
    echo "**Next:** [${next_title}](../${next}/index.md)" >> "$file"
  fi

done

echo "✅ DMBOK next/previous navigation links added."