# Zero Trust MVP - Azure Infrastructure as Code

A production-ready demonstration of Zero Trust security architecture on Microsoft Azure, implementing comprehensive security controls through Infrastructure as Code. This project showcases enterprise-level cloud security design, implementation, and operational practices within a cost-optimized framework.

## Project Overview

This project demonstrates practical implementation of Zero Trust security principles in a cloud environment, featuring network microsegmentation, identity-based access controls, centralized secret management, and comprehensive monitoring. The architecture eliminates stored credentials, implements defense-in-depth strategies, and provides a scalable foundation for enterprise security requirements.

**Key Achievements:**
- Complete Zero Trust Implementation: All 5 core security pillars fully operational
- Cost-Optimized Design: Enterprise security within budget constraints
- Production-Ready Architecture: Scalable foundation for enterprise deployment
- Infrastructure as Code: 100% automated deployment via Terraform
- Zero Stored Credentials: Complete elimination of hardcoded secrets

## Architecture Overview

### Four-Tier Network Security Design
```
Internet → Application Gateway (WAF Protection)
           ↓
         Public Subnet (10.0.1.0/24)
           ↓
         Private App Subnet (10.0.2.0/24) - Web/API Servers
           ↓
         Private Data Subnet (10.0.3.0/24) - Database/Key Vault
           
Administrative Access:
Internet → Bastion Subnet (10.0.4.0/27) → All Private Resources
```

### Zero Trust Principles Demonstrated
- **Never Trust, Always Verify**: Multi-layer authentication and authorization
- **Assume Breach**: Network segmentation limiting blast radius
- **Verify Explicitly**: Continuous security validation and monitoring
- **Least Privilege Access**: Minimal required permissions per identity
- **Protect Data Everywhere**: Encryption at rest and in transit

## Security Controls Implemented

This implementation features a comprehensive four-phase deployment encompassing all essential Zero Trust security domains. Phase 1 establishes the network foundation with a three-tier subnet architecture implementing proper CIDR allocation, Network Security Groups with default-deny rules and explicit allow policies, Application Security Groups for microsegmentation and granular traffic control, creating a secure networking foundation for Zero Trust architecture. Phase 2 delivers identity and data protection through four dedicated managed identities that eliminate stored credentials (VM Identity for testing and Key Vault access, Web Identity for web server secret access, API Identity for API server database access, and Application Gateway Identity for certificate management), Azure Key Vault for centralized secret and certificate management, Ubuntu 22.04 LTS virtual machines with managed disk encryption, and Azure Bastion for secure administrative access without public IPs. Phase 3 implements application security via an enterprise-grade Application Gateway with WAF protection, Web Application Firewall utilizing OWASP Core Rule Set 3.2 for blocking malicious traffic, SSL/TLS termination with automated certificate management via Key Vault, path-based routing enabling separate traffic flows for web and API services, and built-in DDoS protection against volumetric attacks. Phase 4 completes the architecture with monitoring and governance capabilities including Log Analytics Workspace for centralized security event collection and analysis, Azure Policy enforcement through 12+ security policies ensuring compliance, comprehensive diagnostic settings for Application Gateway and security events, cost management with budget alerts and resource optimization controls, and security monitoring encompassing Application Gateway access logs, firewall logs, and performance metrics.

## Technology Stack

### Azure Services
- **Compute**: Azure Virtual Machines (Standard_B1s) with managed disks
- **Networking**: Virtual Network, Subnets, NSGs, ASGs, Application Gateway
- **Security**: Key Vault, Azure Bastion, Web Application Firewall
- **Identity**: Azure Active Directory with User-Assigned Managed Identities
- **Monitoring**: Log Analytics Workspace, Azure Monitor, diagnostic settings
- **Governance**: Azure Policy assignments and compliance monitoring

### Infrastructure as Code
- **Terraform**: Version >= 1.0 with modular architecture
- **AzureRM Provider**: Version ~> 3.80 for latest Azure features
- **Modular Design**: Separate modules for networking, security, compute, identity, monitoring, and governance