# Salesforce Lead Deduplication Script

This repository contains an Apex script for deduplicating leads in Salesforce. The script identifies and resolves duplicate leads based on specified criteria, ensuring cleaner and more efficient lead management in your Salesforce org.

---

## 🚀 Features

- Detects duplicate leads using name and email.
- Deletes duplicate leads while preserving the oldest lead.
- Handles exceptions to ensure data integrity.
- Easy to configure and extend for your specific business needs.

---

## ⚙️ Configuration

Modify the `LeadDuplicateCleaner.cls` class to adjust:
- **Fields used for matching** (e.g., Email, Phone).
- **Rules for deleting duplicates** (e.g., current rule is to prioritize the oldest lead).

Ensure the test class reflects your business rules to maintain high code coverage.

---

## 📋 Usage

The script can be automated using:
- **Apex Scheduler**
- **Salesforce Flows or Triggers**

---

## ✅ Testing

The repository includes a comprehensive test class (`LeadDuplicateCleanerTest.cls`) with test cases covering:
- Detection of duplicates.
- Successful deletion of leads.
- Exception handling.

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

## 📧 Contact

For questions or support, reach out at [tdjwalsh@hotmail.com](mailto:tdjwalsh@hotmail.com).
