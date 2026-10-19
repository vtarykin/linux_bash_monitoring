#!/bin/bash

write_to_file_prompt() {
    read -p "Would you like to store this information to a .status file? (Y/N): " response

    if [[ "${response,,}" == "y" ]]; then
        FILENAME=$(date +"%d_%m_%y_%H_%M_%S.status")
        output_system_info > "$FILENAME"
        echo "Data saved to $FILENAME"
    else
        echo "Data not saved."
    fi
}
