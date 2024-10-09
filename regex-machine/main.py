import re

class EmailValidator:
    def __init__(self):
        # Regular expression for email validation
        self.email_regex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        
        # Maximum lengths for email parts
        self.MAX_LOCAL_LENGTH = 64    # Local part max length
        self.MAX_DOMAIN_LENGTH = 255  # Domain max length
        self.MIN_LENGTH = 3          # Minimum total length (a@b.c)
        
    def validate_email(self, email: str) -> tuple[bool, str]:
        """
        Validates an email address and returns a tuple of (is_valid, error_message).
        
        Args:
            email: The email address to validate
            
        Returns:
            tuple[bool, str]: (is_valid, error_message)
        """
        try:
            # Check if email is None or empty
            if not email:
                return False, "Email cannot be empty"
            
            # Remove leading/trailing whitespace
            email = email.strip()
            
            # Check total length
            if len(email) < self.MIN_LENGTH:
                return False, "Email is too short"
                
            # Split email into local and domain parts
            try:
                local_part, domain = email.split('@')
            except ValueError:
                return False, "Email must contain exactly one '@' symbol"
            
            # Check lengths
            if len(local_part) > self.MAX_LOCAL_LENGTH:
                return False, f"Local part cannot exceed {self.MAX_LOCAL_LENGTH} characters"
                
            if len(domain) > self.MAX_DOMAIN_LENGTH:
                return False, f"Domain cannot exceed {self.MAX_DOMAIN_LENGTH} characters"
                
            # Check if local part or domain is empty
            if not local_part:
                return False, "Local part cannot be empty"
                
            if not domain:
                return False, "Domain cannot be empty"
                
            # Check for consecutive dots
            if '..' in email:
                return False, "Email cannot contain consecutive dots"
                
            # Check if domain has at least one dot
            if '.' not in domain:
                return False, "Domain must contain at least one dot"
                
            # Check domain parts
            domain_parts = domain.split('.')
            if len(domain_parts[-1]) < 2:
                return False, "Top-level domain must be at least 2 characters"
                
            # Check against regex pattern
            if not re.match(self.email_regex, email):
                return False, "Email contains invalid characters or format"
            
            return True, "Email is valid"
            
        except Exception as e:
            return False, f"Validation error: {str(e)}"

def main():
    # Create validator instance
    validator = EmailValidator()
    
    # Test cases
    test_emails = [
        "test@example.com",
        "user.name+tag@example.co.uk",
        "invalid.email@",
        "@invalid.com",
        "invalid@.com",
        "invalid@com",
        "test..test@example.com",
        "test@example..com",
        "a"*65 + "@example.com",  # Too long local part
        "test@" + "a"*256 + ".com",  # Too long domain
        "valid_email123@sub.example.com",
        "  spaces@example.com  ",  # Test trimming
        "special!#@example.com",  # Invalid characters
        "no.dots@domaincom"  # Missing dot in domain
    ]
    
    # Test each email
    for email in test_emails:
        is_valid, message = validator.validate_email(email)
        print(f"\nTesting: {email}")
        print(f"Result: {'Valid' if is_valid else 'Invalid'}")
        print(f"Message: {message}")

if __name__ == "__main__":
    main()