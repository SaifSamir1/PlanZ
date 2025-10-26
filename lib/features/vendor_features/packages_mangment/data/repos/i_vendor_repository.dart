import '../models/vendor_model.dart';
import '../models/package_model.dart';
import '../models/notification_model.dart';

abstract class IVendorRepository {
  //  Vendor operations
  Future<VendorModel?> getVendorById(String vendorId);
  Future<void> addVendor(VendorModel vendor);
  Future<void> updateVendor(VendorModel vendor);
  Future<void> deleteVendor(String vendorId);

  //  Package operations
  Future<void> addPackage(PackageModel package);
  Future<void> updatePackage(PackageModel package);
  Future<void> deletePackage(String packageId);
  Future<List<PackageModel>> getVendorPackages(String vendorId);

  //  Notification operations
  Future<void> sendNotificationToVendor(
    String vendorId,
    NotificationModel notification,
  );
  Future<List<NotificationModel>> getVendorNotifications(String vendorId);
}
