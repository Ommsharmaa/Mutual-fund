source home.sh
#!/bin/bash

# Function to display the login dialog
function show_login_dialog() {
    #!/bin/bash

    # Function to display a dialog box and capture user input
    input_box() {
        local title="$1"
        local message="$2"
        local default_value="$3"

        whiptail --title "$title" --inputbox "$message" 10 60 "$default_value" 3>&1 1>&2 2>&3
    }

    # Function to display an error dialog box
    error_box() {
        local message="$1"
        whiptail --title "Error" --msgbox "$message" 10 60
    }

    # Collect user login data
    email=$(input_box "Login" "Enter your email:" "")
    password=$(whiptail --title "Login" --passwordbox "Enter your password:" 10 60 3>&1 1>&2 2>&3)

    # Validate user data (you can add more validation as per your requirements)
    if [[ -z $email || -z $password ]]; then
        error_box "Please provide your email and password."
        exit 1
    fi

    # MySQL credentials
    db_host="localhost"
    db_user="root"
    db_password="Root@123"
    db_name="mutualfund"

    # Query the MySQL table for the entered credentials
    result=$(mysql -h "$db_host" -u "$db_user" -p"$db_password" -D "$db_name" -Bse "SELECT COUNT(*) FROM user WHERE email = '$email' AND password = '$password';")

    # Check the result
    if [ "$result" -eq 1 ]; then
        # Display success message
        whiptail --title "Success" --msgbox "Login successful!" 10 60
        home $email
    else
        # Display error message
        error_box "Invalid email or password. Please try again."
    fi

}

# Function to display the signup dialog
function show_signup_dialog() {
    #!/bin/bash

    # Function to display a dialog box and capture user input
    input_box() {
        local title="$1"
        local message="$2"
        local default_value="$3"

        whiptail --title "$title" --inputbox "$message" 10 60 "$default_value" 3>&1 1>&2 2>&3
    }

    # Function to display an error dialog box
    error_box() {
        local message="$1"
        whiptail --title "Error" --msgbox "$message" 10 60
    }

    # Collect user registration data
    name=$(input_box "Register" "Enter your name:" "")
    email=$(input_box "Register" "Enter your email:" "")
    password=$(whiptail --title "Register" --passwordbox "Enter your password:" 10 60 3>&1 1>&2 2>&3)

    # Validate user data (you can add more validation as per your requirements)
    if [[ -z $name || -z $email || -z $password ]]; then
        error_box "Please provide all the required information."
        exit 1
    fi

    # MySQL credentials
    db_host="localhost"
    db_user="root"
    db_password="Root@123"
    db_name="mutualfund"

    # Insert user data into MySQL table
    mysql -h "$db_host" -u "$db_user" -p"$db_password" "$db_name" <<EOF
INSERT INTO user (name, email, password) VALUES ('$name', '$email', '$password');
EOF

    # Display success message
    whiptail --title "Success" --msgbox "Registration successful!" 10 60

}

# Main menu
while true; do
    choice=$(whiptail --menu "Choose an option:" 12 40 4 \
        "1" "Login" \
        "2" "Signup" \
        "3" "Exit" 3>&1 1>&2 2>&3)

    case $choice in
    1)
        show_login_dialog
        ;;
    2)
        show_signup_dialog
        ;;
    3)
        exit
        ;;
    esac
done
