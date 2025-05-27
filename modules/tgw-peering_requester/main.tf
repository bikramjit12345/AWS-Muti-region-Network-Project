resource "aws_ec2_transit_gateway_peering_attachment" "natgw_peering" {

  transit_gateway_id      = var.requester_tgw_id
  peer_transit_gateway_id = var.peer_twg_id
  peer_region             = var.peer_region


}

