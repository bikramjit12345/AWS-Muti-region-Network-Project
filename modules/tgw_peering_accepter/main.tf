resource "aws_ec2_transit_gateway_peering_attachment_accepter" "peer_accepter" {
  transit_gateway_attachment_id = var.attachment_id

}