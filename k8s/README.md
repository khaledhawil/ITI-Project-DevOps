# 3-Tier E-commerce Application - Kubernetes Deployment

This directory contains the essential Kubernetes manifests to deploy a complete 3-tier e-commerce application.

## 🏗️ Architecture

- **Presentation Tier**: React.js Frontend (LoadBalancer Service)
- **Application Tier**: Node.js Backend API (ClusterIP Service)  
- **Data Tier**: MongoDB Database (ClusterIP Service with Persistent Storage)

## 📁 Essential Files

| File | Description |
|------|-------------|
| `01-namespace.yaml` | Creates the ecommerce namespace |
| `secrets.yaml` | MongoDB credentials and JWT secret |
| `configmap.yaml` | Application configuration |
| `mongodb-pvc.yaml` | Persistent storage for MongoDB |
| `mongodb.yaml` | MongoDB database deployment and service |
| `backend.yaml` | Node.js backend API deployment and service |
| `frontend.yaml` | React.js frontend deployment and LoadBalancer service |
| `deploy.sh` | Automated deployment script |
| `cleanup.sh` | Cleanup script to remove all resources |

## 🚀 Quick Deployment

### Prerequisites
- Kubernetes cluster (EKS, GKE, AKS, or local)
- kubectl configured and connected to your cluster
- At least 2GB of available memory in your cluster

### Deploy Application

```bash
# Make scripts executable
chmod +x deploy.sh cleanup.sh

# Deploy the application
./deploy.sh
```

### Manual Deployment (Step by Step)

```bash
# 1. Create namespace
kubectl apply -f 01-namespace.yaml

# 2. Create secrets and config
kubectl apply -f secrets.yaml
kubectl apply -f configmap.yaml

# 3. Create storage
kubectl apply -f mongodb-pvc.yaml

# 4. Deploy database tier
kubectl apply -f mongodb.yaml

# 5. Deploy application tier
kubectl apply -f backend.yaml

# 6. Deploy presentation tier
kubectl apply -f frontend.yaml
```

## 🔍 Verify Deployment

```bash
# Check all pods are running
kubectl get pods -n ecommerce

# Check services
kubectl get services -n ecommerce

# Get frontend URL
kubectl get service frontend-service -n ecommerce
```

## 🔗 Access Application

The frontend service is configured as a LoadBalancer. Once deployed:

1. Get the external IP/URL:
   ```bash
   kubectl get svc frontend-service -n ecommerce
   ```

2. Access the application at `http://<EXTERNAL-IP>`

## 📊 Default Configuration

- **Frontend**: 2 replicas, exposed on port 80
- **Backend**: 2 replicas, internal port 5000
- **MongoDB**: 1 replica with persistent storage (10Gi)
- **Resources**: Optimized for small to medium workloads

## 🧹 Cleanup

```bash
# Remove all resources
./cleanup.sh

# Or manually
kubectl delete namespace ecommerce
```

## 🔧 Customization

### Update Docker Images

Edit the image tags in:
- `backend.yaml`: Change `abdoelshahat/amazona-backend:latest`
- `frontend.yaml`: Change `abdoelshahat/amazona-frontend:latest`

### Scale Applications

```bash
# Scale frontend
kubectl scale deployment frontend --replicas=3 -n ecommerce

# Scale backend
kubectl scale deployment backend --replicas=3 -n ecommerce
```

### Update Configuration

Modify `configmap.yaml` and `secrets.yaml`, then:
```bash
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml
kubectl rollout restart deployment/backend -n ecommerce
```

## 🐛 Troubleshooting

### Check Pod Status
```bash
kubectl get pods -n ecommerce
kubectl describe pod <pod-name> -n ecommerce
```

### View Logs
```bash
# Frontend logs
kubectl logs -f deployment/frontend -n ecommerce

# Backend logs
kubectl logs -f deployment/backend -n ecommerce

# MongoDB logs
kubectl logs -f deployment/mongodb -n ecommerce
```

### Common Issues

1. **Pods in Pending state**: Check if cluster has enough resources
2. **ImagePullBackOff**: Verify Docker image names and registry access
3. **MongoDB connection issues**: Check if MongoDB pod is running and ready

## 📈 Monitoring

```bash
# Watch pods status
kubectl get pods -n ecommerce -w

# Check resource usage
kubectl top pods -n ecommerce
kubectl top nodes
```

---

**Ready to deploy your 3-tier e-commerce application!** 🎯
