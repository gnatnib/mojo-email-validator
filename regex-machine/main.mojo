struct ValidationResult:
    var is_valid: Bool
    var message: String
    
    fn __init__(inout self, is_valid: Bool, message: String):
        self.is_valid = is_valid
        self.message = message

struct EmailValidator:
    var max_local_length: Int
    var max_domain_length: Int
    var min_length: Int
    
    fn __init__(inout self):
        self.max_local_length = 64
        self.max_domain_length = 255
        self.min_length = 3
    
    fn is_valid_char(self, c: Int) -> Bool:
        if c >= ord('a') and c <= ord('z'):
            return True
        if c >= ord('A') and c <= ord('Z'):
            return True
        if c >= ord('0') and c <= ord('9'):
            return True
        if c == ord('.') or c == ord('_') or c == ord('-') or c == ord('+'):
            return True
        return False
    
    fn validate_email(self, email: String) -> ValidationResult:
        var at_count = 0
        var dot_count = 0
        var local_length = 0
        var domain_length = 0
        var in_domain = False
        var previous_char_was_dot = False
        
        if len(email) == 0:
            return ValidationResult(False, "Email tidak boleh kosong.")
        
        if len(email) < self.min_length:
            return ValidationResult(False, "Email terlalu pendek.")
        
        # First pass: count @ symbols and validate characters
        var i = 0
        while i < len(email):
            var c = ord(email[i])
            
            if c == ord('@'):
                at_count += 1
                in_domain = True

                if i+1 < len(email) and ord(email[i+1]) == ord('.'):
                    return ValidationResult(False, "Domain tidak boleh dimulai dengan titik setelah '@'.")
            else:
                if not in_domain:
                    local_length += 1
                else:
                    domain_length += 1
                    if c == ord('.'):
                        dot_count += 1
                        if previous_char_was_dot:
                            return ValidationResult(False, "Domain tidak boleh memiliki dua titik berturut-turut.")
                        previous_char_was_dot = True
                    else:
                        previous_char_was_dot = False
                if not self.is_valid_char(c) and c != ord('.'):
                    return ValidationResult(False, "Karakter invalid pada email.")
            
            i += 1
        
        # Validation checks
        if at_count != 1:
            return ValidationResult(False, "Email harus memiliki satu simbol '@'.")
        
        if local_length == 0:
            return ValidationResult(False, "Email sebelum '@' tidak boleh kosong.")
        
        if domain_length == 0:
            return ValidationResult(False, "Domain tidak boleh kosong.")
        
        if local_length > self.max_local_length:
            return ValidationResult(False, "Email sebelum '@' terlalu panjang.")
        
        if domain_length > self.max_domain_length:
            return ValidationResult(False, "Domain terlalu panjang.")
        
        if dot_count == 0:
            return ValidationResult(False, "Domain harus memiliki minimal satu titik.")

        if email[len(email) -1 ] == '.':
            return ValidationResult(False, "Domain tidak boleh diakhiri dengan titik.")
        
        return ValidationResult(True, "Email valid!")

    fn test_email(self, email: String):
        var result = self.validate_email(email)
        print("Testing: " + email)
        if result.is_valid:
            print("Result: Valid")
        else:
            print("Result: Invalid")
        print("Message: " + result.message)
        print("")
    
    fn run_tests(self):
        self.test_email("test@example.com")
        self.test_email("user.name+tag@example.co.uk")
        self.test_email("invalid.email@")
        self.test_email("@invalid.com")
        self.test_email("invalid@.com")
        self.test_email("invalid@com")
        self.test_email("test..test@example.com")
        self.test_email("special!#@example.com")
        self.test_email("no.dots@domaincom")
        self.test_email("bintang.syafrian@gmail.com")

fn main():
    var validator = EmailValidator()
    validator.run_tests()
