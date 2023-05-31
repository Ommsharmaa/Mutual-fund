#!/bin/bash
source profile.sh

function home() {
    while [ $? -eq 0 ]; do
        selection=$(
            whiptail --backtitle "Company" --title "$companyy" --menu "Select Options" 0 0 0 \
                1 "List of Mutual Fund" \
                2 "Dashboard" \
                3 "Profile" \
                4 "Exit" \
                3>&1 1>&2 2>&3 3>&-
        )

        #read -p "enter company symbol: " company
        case $selection in
        1)

            source fundbuy.sh

            ;;
        2)

            while true; do
                choice=$(whiptail --menu "Choose an option:" 12 40 4 \
                    "1" "Investments" \
                    "2" "Wallet" \
                    "3" "Exit" 3>&1 1>&2 2>&3)

                case $choice in
                1)
                    whiptail --backtitle "OM SHARMA" --title "INVESTMENTS" --textbox 0 0
                    
                    ;;
                2)
                    whiptail --backtitle "OM SHARMA" --title "WALLET" --textbox 0 0
                    ;;
                3)
                    break
                    ;;
                esac
            done

            ;;
        3)

            whiptail --backtitle "$companyy" --title "Profit_gained by the $companyy" --textbox 0 0
            profile $1

            ;;
        4)
            break
            ;;

        esac

    done
}
