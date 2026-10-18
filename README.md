## Summary

This Pull Request introduces the Amazon EKS infrastructure configuration using reusable Terraform modules. It builds on the existing VPC networking foundation and prepares the platform for Kubernetes workload deployments.

The implementation focuses on infrastructure modularity, security, IAM permissions, controlled resource dependencies, and reproducible deployments.

## Changes Made

### 1. Amazon EKS Cluster

- Configured an Amazon EKS control plane running Kubernetes version `1.36`.
- Configured managed worker nodes using `t3.medium` On-Demand EC2 instances.
- Deployed worker-node configuration across two private subnets in separate Availability Zones.
- Enabled private Kubernetes API endpoint access.
- Restricted public API endpoint access to a specified `/32` CIDR.
- Configured managed node group scaling:
  - Desired capacity: 2
  - Minimum capacity: 2
  - Maximum capacity: 3
- Configured rolling node updates with `max_unavailable = 1`.

### 2. IAM and Security

Created three dedicated IAM roles following least-privilege principles:

**EKS Cluster Role**
- Configured the Amazon EKS service trust relationship.
- Attached `AmazonEKSClusterPolicy`.

**EKS Worker Node Role**
- Configured the EC2 service trust relationship.
- Attached `AmazonEKSWorkerNodePolicy`.
- Attached `AmazonEC2ContainerRegistryPullOnly` for ECR image pulls.

**VPC CNI Role**
- Configured a dedicated IAM role for Kubernetes Pod networking.
- Attached `AmazonEKS_CNI_Policy`.
- Configured EKS Pod Identity with the `aws-node` Kubernetes service account.

Additional security considerations:
- Kept worker nodes in private subnets.
- Restricted public Kubernetes API access.
- Separated cluster, worker-node, and networking IAM permissions.
- Added Terraform module dependencies to ensure IAM policies are attached before EKS resource creation.

### 3. Kubernetes Managed Add-ons

Configured four Amazon EKS managed add-ons with explicitly pinned versions compatible with Kubernetes `1.36`.

| Add-on | Version | Purpose |
|---|---|---|
| Amazon VPC CNI | `v1.22.4-eksbuild.3` | Pod networking and IP allocation |
| kube-proxy | `v1.36.0-eksbuild.48` | Kubernetes Service traffic routing |
| CoreDNS | `v1.14.7-eksbuild.11` | Kubernetes DNS resolution |
| EKS Pod Identity Agent | `v1.3.10-eksbuild.3` | IAM credential delivery to Pods |

Configured explicit resource dependencies for add-on installation and managed node group provisioning.

### 4. Terraform Infrastructure Integration

- Integrated the reusable EKS module into the development environment.
- Integrated the reusable IAM module.
- Connected the EKS cluster to VPC private subnet outputs.
- Corrected the VPC module output name from `private_subnet_id` to `private_subnet_ids`.
- Added configurable Kubernetes API access CIDRs.
- Disabled default self-managed EKS add-on bootstrapping to manage core add-ons explicitly through Terraform.
- Applied consistent resource naming and tagging conventions.

### 5. Validation Performed

The following checks were performed successfully:

- [x] Terraform formatting checks
- [x] `terraform validate`
- [x] `terraform plan`
- [x] Verified EKS add-on version availability for Kubernetes 1.36 in `ca-central-1`
- [x] Reviewed IAM roles, trust policies, and policy attachments
- [x] Reviewed Terraform resource dependencies
- [x] Reviewed Git staged changes and whitespace checks
- [ ] Deployed infrastructure to AWS
- [ ] Verified EKS cluster health
- [ ] Verified managed worker-node readiness
- [ ] Verified Kubernetes add-on health and Pod networking

**Final Terraform Plan:**

```text
Plan: 31 to add, 0 to change, 0 to destroy.
```

### 6. Deployment Status

**Infrastructure configured and validated — deployment pending.**

This PR covers the infrastructure-as-code implementation only.

The AWS resources have not yet been provisioned. Actual infrastructure deployment and runtime validation will be performed in the next project phase.

The deployment process will include verification of IAM permissions, node registration, Kubernetes networking, Pod Identity, and add-on health.

### 7. Next Steps

- Deploy the EKS infrastructure using Terraform.
- Verify cluster connectivity using `kubectl`.
- Confirm managed worker nodes successfully join the cluster.
- Validate VPC CNI, CoreDNS, kube-proxy, and Pod Identity Agent.
- Deploy containerized Nginx and Flask application workloads.
- Configure application ingress using AWS Load Balancer Controller.
- Integrate CI/CD, GitOps, and container security scanning using Jenkins, Argo CD, and Trivy.
- Implement monitoring, logging, and autoscaling using Prometheus, Grafana, Loki, HPA, and Karpenter.
- Document deployment verification, troubleshooting findings, and operational procedures.

---

## Engineering Considerations

This implementation prioritizes modular infrastructure, least-privilege IAM access, explicit resource dependencies, and reproducible Terraform configurations.

The goal is to establish a secure, maintainable, and scalable Kubernetes foundation that supports future application deployments and platform engineering capabilities.
