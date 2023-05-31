#!/bin/bash

# Run credo and save the output to a file
mix credo --format=flycheck --all --strict > credo_output.txt

# Initialize the SARIF file
echo '{
  "$schema": "https://schemastore.azurewebsites.net/schemas/json/sarif-2.1.0-rtm.5.json",
  "version": "2.1.0",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "Credo",
          "informationUri": "https://hexdocs.pm/credo/"
        }
      },
      "results": [' > output.sarif

# Parse the credo output and convert each line into a SARIF result
grep '^lib/' credo_output.txt | while read -r line ; do
  file=$(echo "$line" | cut -d: -f1)
  line_number=$(echo "$line" | cut -d: -f2)
  column=$(echo "$line" | cut -d: -f3)
  message=$(echo "$line" | cut -d: -f4-)

  echo '        {
    "level": "warning",
    "message": {
      "text": "'$message'"
    },
    "locations": [
      {
        "physicalLocation": {
          "artifactLocation": {
            "uri": "'$file'",
            "index": -1
          },
          "region": {
            "startLine": '$line_number',
            "startColumn": '$column'
          }
        }
      }
    ]
  },' >> output.sarif
done

# Close the SARIF file
echo '      ]
      }
    ]
}' >> output.sarif
