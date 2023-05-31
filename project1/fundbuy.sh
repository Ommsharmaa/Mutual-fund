#!/bin/bash
db_host="localhost"
db_user="root"
db_pass="Root@123"
db_name="mutualfund"
#!/bin/bash

# Function to display the buy/sell page
function show_buy_sell_page() {
    username="$1"
    mutual_fund="$2"

    # Check if the mutual fund has been bought by the user
    bought=$(mysql -h "$db_host" -u "$db_user" -p"$db_pass" -D "$db_name" -Bse "SELECT COUNT(*) FROM user_mutual_funds WHERE username = '$username' AND mutual_fund = '$mutual_fund'")

    # Display the buy/sell page
    while true; do
        action=$(whiptail --menu "Select action:" 12 40 2 "Buy" "Buy mutual fund" "Sell" "Sell mutual fund" --title "Action" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [[ $exitstatus -ne 0 ]]; then
            echo "User input canceled."
            exit 1
        fi

        # Insert or delete the record in the database based on the action
        if [[ "$action" == "Buy" ]]; then
            # Insert the record
            mysql -h "$db_host" -u "$db_user" -p"$db_pass" -D "$db_name" -e "INSERT INTO user_mutual_funds (username, mutual_fund) VALUES ('$username', '$mutual_fund')"
            whiptail --msgbox "Mutual fund purchased successfully." 8 40 --title "Success"
        elif [[ "$action" == "Sell" ]]; then
            if [[ "$bought" -eq 0 ]]; then
                # User hasn't bought the mutual fund
                whiptail --msgbox "You haven't bought this mutual fund. Sell is not allowed." 8 40 --title "Error"
            else
                # Delete the record
                mysql -h "$db_host" -u "$db_user" -p"$db_pass" -D "$db_name" -e "DELETE FROM user_mutual_funds WHERE username = '$username' AND mutual_fund = '$mutual_fund'"
                whiptail --msgbox "Mutual fund sold successfully." 8 40 --title "Success"
            fi
        else
            whiptail --msgbox "Invalid action. Please specify 'Buy' or 'Sell'." 8 40 --title "Error"
        fi
    done
}

# Fetch mutual fund data from MySQL
data=$(mysql -h "$db_host" -u "$db_user" -p"$db_pass" -D "$db_name" -Bse "SELECT name, price FROM mutual_funds")

# Parse data and construct a list
list=()
while IFS=$'\t' read -r name price; do
    list+=("$name" "$price")
done <<< "$data"

# Display the list using whiptail and get the selected mutual fund
selected_mutual_fund=$(whiptail --menu "Choose a mutual fund:" 15 60 8 "${list[@]}" 3>&1 1>&2 2>&3)
exitstatus=$?
if [[ $exitstatus -ne 0 ]]; then
    echo "User input canceled."
    
fi

# Get the username from the user
username=$(whiptail --inputbox "Enter username:" 8 40 --title "User Input" 3>&1 1>&2 2>&3)
exitstatus=$?
if [[ $exitstatus -ne 0 ]]; then
    echo "User input canceled."
    exit 1
fi

# Check if the mutual fund has been bought by the user
bought=$(mysql -h "$db_host" -u "$db_user" -p"$db_pass" -D "$db_name" -Bse "SELECT COUNT(*) FROM user_mutual_funds WHERE username = '$username' AND mutual_fund = '$selected_mutual_fund'")

# If the user hasn't bought the mutual fund, display an error message and redirect to the buy/sell page


show_buy_sell_page "$username" "$selected_mutual_fund"


