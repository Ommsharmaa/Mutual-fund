#!/bin/bash
function profile(){
# Function to display a dialog box
show_dialog() {
    local title="$1"
    local message="$2"

    whiptail --title "$title" --msgbox "$message" 10 60
}

# Function to fetch user details from MySQL table
fetch_user_details() {
    local email="$1"
    local db_host="localhost"
    local db_user="root"
    local db_password="Root@123"
    local db_name="mutualfund"

    # Fetch user details from MySQL table
    local query="SELECT name, email FROM user WHERE email = '$email';"
    local result=$(mysql -h "$db_host" -u "$db_user" -p"$db_password" -D "$db_name" -Bse "$query")

    # Parse the result
    local name=$(echo "$result" | awk '{print $1}')
    local email=$(echo "$result" | awk '{print $2}')

    # Return the user details
    echo "$name,$email"
}

# Function to fetch user's mutual funds from MySQL table
fetch_mutual_funds() {
    local email="$1"
    local db_host="localhost"
    local db_user="root"
    local db_password="Root@123"
    local db_name="mutualfund"

    # Fetch user's mutual funds from MySQL table
    local query="SELECT fund_name FROM mutual_funds WHERE email = '$email';"
    local result=$(mysql -h "$db_host" -u "$db_user" -p"$db_password" -D "$db_name" -Bse "$query")

    # Return the list of mutual funds
    echo "$result"
}


# Prompt the user for their email
email="$1"

# Validate user's email
if [[ -z $email ]]; then
    show_dialog "Error" "Please provide your email."
    exit 1
fi

# Fetch user details and mutual funds from MySQL
user_details=$(fetch_user_details "$email")
mutual_funds=$(fetch_mutual_funds "$email")

# Parse user details
name=$(echo "$user_details" | awk -F',' '{print $1}')
email=$(echo "$user_details" | awk -F',' '{print $2}')

# Display user profile
whiptail --title "Profile Page" --msgbox "Name: $name\nEmail: $email\n\nMutual Funds Bought:\n$mutual_funds" 20 60
}
