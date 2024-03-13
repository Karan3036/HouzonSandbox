import { LightningElement, track } from 'lwc';

export default class PropertyFinderSelectUAE extends LightningElement {
    options = ['Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 5'];
    filteredOptions = [];
    dropdownClass = 'dropdown-content';

    toggleDropdown() {
        this.dropdownClass = 'dropdown-content show';
    }

    hideDropdown() {
        // Use a setTimeout to wait for the click event to propagate before hiding the dropdown
        setTimeout(() => {
            this.dropdownClass = 'dropdown-content';
        }, 300);
    }

    handleSearch(event) {
        const searchTerm = event.target.value.toLowerCase();
        this.filteredOptions = this.options.filter(option => option.toLowerCase().includes(searchTerm));
        this.toggleDropdown();
    }

    handleOptionClick(event) {
        // Handle option click logic if needed
    }
}